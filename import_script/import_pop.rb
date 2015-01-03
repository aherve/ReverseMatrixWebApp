ARGF.each do |line|
  ll  = line.chomp.split("\t")
  pop = ll.last.strip.to_i * 100
  codename = ll[1]

  t = Town.find_by(codename: codename)
  if t
    puts t.update_attribute(:population, pop) 
  else
    puts "NOT FOUND: #{codename}"
  end
end
