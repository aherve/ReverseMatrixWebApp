gulp = require 'gulp'
gutil = require 'gulp-util'
connect = require 'gulp-connect'
jade = require 'gulp-jade'
sass = require 'gulp-sass'
sourcemaps = require 'gulp-sourcemaps'
coffee = require 'gulp-coffee'
inject = require 'gulp-inject'
karma = require 'gulp-karma'
changed = require 'gulp-changed'
watch = require 'gulp-watch'
plumber = require 'gulp-plumber'
globs = require './globs'
series = require 'stream-series'
path = require('path')
filter = require('gulp-filter')
concat = require('gulp-concat')
rename = require('gulp-rename')
gulpif = require('gulp-if')
url = require('url')
proxy = require('proxy-middleware')

# Paths
index_path = 'build/index.html'
src_dir = 'src/'
build_dir = 'build/'
build_vendor_dir = 'build/vendor/'
build_assets_dir = 'build/assets/'


`
gulp.task('connect', function(){
    connect.server({
        root: ['build'], 
        livereload: true,
        middleware: function(connect, o) {
          return [ (function() {
            var url = require('url');
            var proxy = require('proxy-middleware');
            var options = url.parse('http://localhost:3000/api');
            options.route = '/api';
            return proxy(options);
          })()]
        }
    });
});
`


gulp.task 'move:jade', ->
	gulp.src globs.jade
	.pipe plumber()
	.pipe jade({ pretty : true })
	.pipe inject(gulp.src(globs.app, { read : false }), { ignorePath : ['build'], addRootSlash : false })
	.pipe gulp.dest(build_dir)


gulp.task 'move:sass', ->
  gulp.src globs.sass
    .pipe plumber()
    .pipe(concat('main.scss'))
    .pipe(sourcemaps.init())
    .pipe(sass())
    .pipe(sourcemaps.write())
    .pipe(rename (path)->
      path.dirname = '/style'
      path
    )
    .pipe gulp.dest(build_dir)

gulp.task 'move:coffee', ->
	gulp.src globs.coffee
	.pipe plumber()
	.pipe coffee({ bare : true })
	.pipe gulp.dest(build_dir)

gulp.task 'move:assets', ->
	gulp.src globs.assets
	.pipe plumber()
	.pipe gulp.dest(build_assets_dir)


gulp.task 'move:vendor', ->
	gulp.src globs.vendor
	.pipe plumber()
	.pipe gulp.dest(build_vendor_dir)


gulp.task 'run:karma', ->
	gulp.src globs.karma
	.pipe karma
		configFile : 'karma.conf.js'
		action : 'watch'
	.on 'error', (err) ->
		throw err
		return


gulp.task 'watch', ->
	gulp.watch globs.vendor, ['move:vendor']
	gulp.watch globs.jade, ['move:jade']
	gulp.watch globs.assets, ['move:assets']
	gulp.watch globs.sass, ['move:sass']
	gulp.watch globs.coffee, ['move:coffee']
	gulp.watch globs.karma, ['run:karma']
	

gulp.task 'move:files', ['move:vendor', 'move:sass', 'move:assets', 'move:coffee'], ->
	gulp.start 'move:jade'

gulp.task 'default', ['move:files', 'connect', 'watch']
