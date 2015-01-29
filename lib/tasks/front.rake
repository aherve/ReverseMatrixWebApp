namespace :front do

  desc "build front application"
  task :build do 
    Dir.chdir('FrontApp') do
      sh "pwd"
      sh "npm install"
      sh "bower install"
      sh "gulp clean:all"
      sh "gulp build"
      sh "gulp build"
      sh "gulp compile"
      sh "rsync -Pa bin/ ../public/"
    end
  end

  desc "test front application"
  task :test do 
    Dir.chdir('FrontApp') do
      sh "pwd"
      sh "npm install"
      sh "bower install"
      sh "gulp clean:build"
      sh "gulp build"
      sh "gulp build"
      sh "gulp test"
    end
  end

end
