VERSION="0.1.6"

class Urleap < Formula
  desc "URL shortener via bit.ly"
  homepage "https://github.com/tamada/urleap"
  version VERSION
  license "MIT"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/urleap/releases/download/v#{VERSION}/urleap-#{VERSION}_darwin_amd64.tar.gz"
    sha256 "72865931aea7ea1231e8dc100468d54393a4f1c485ab636b9f8a479dc8aa9928"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/urleap/releases/download/v#{VERSION}/urleap-#{VERSION}_darwin_arm64.tar.gz"
    sha256 "af98f0d6699203531139815de9223a71d543d14446b1e60f5b77a005eeca7454"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/urleap/releases/download/v#{VERSION}/urleap-#{VERSION}_linux_amd64.tar.gz"
    sha256 "42f0d6e75dc6215f95d4309895a6eea91f93d4400ab9d06497227dbcf186aa6d"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/urleap/releases/download/v#{VERSION}/urleap-#{VERSION}_linux_arm64.tar.gz"
    sha256 "b35bed4f8570966d9cefeb673b37ccfd3685a3fe922821143243b9b73671a02c"
  end

  def install
    bin.install "urleap"

    bash_completion.install "completions/bash/urleap" if build.with? "completions"
    zsh_completion.install  "completions/zsh/urleap"  if build.with? "completions"
    fish_completion.install "completions/fish/urleap" if build.with? "completions"
  end

  test do
    system "#{bin}/urleap --version"
  done
end
