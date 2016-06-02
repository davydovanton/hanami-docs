# require 'rdoc/task'
require 'git'

REPOSITORIES = %w[hanami router controller model validations utils view helpers mailer assets]

desc 'clone all repos'
task :clone_repos do
  REPOSITORIES.each do |repo|
    print_status("Clone #{repo} repo") do
      Git.clone "git://github.com/hanami/#{repo}.git", "sources/#{repo}"
    end
  end
end



def print_status(msg)
  print msg.ljust(65)

  begin
    yield
    puts "[\033[32m DONE \033[0m]"
  rescue Exception => e
    puts "[\033[31m FAIL \033[0m]"
    raise e
  end
end
