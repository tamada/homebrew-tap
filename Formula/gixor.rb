
VERSION="0.3.0"

class Gixor < Formula
  desc "gitignore management system for the multiple repositories"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/gixor"
  version VERSION
  license "MIT license"

  
  
  
  
  
    
      
    
    
    
    
  
    
    
      
    
    
    
  
    
    
    
    
      
    
  

  

  

  

  

  def install
    bin.install "gixor"
    system "ln -s \"#{bin}/gixor\" #{bin}/git-ignore"

    bash_completion.install "assets/completions/bash/gixor" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_gixor" if build.with? "completions"
    fish_completion.install "assets/completions/fish/gixor" if build.with? "completions"
  end

  test do
    system "#{bin}/gixor --version"
  end
end
