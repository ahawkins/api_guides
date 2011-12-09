task :generate do 
  `rvm gemset use 1.9.3@rocco ; rocco -o #{Dir.pwd} ~/projects/api_guides/lib/**/*.rb ; mv Users/adam/projects/api_guides/lib/api_guides/*.html . ; rm -rf Users/ ; cp document.html index.html`
end

task :default => :generate
