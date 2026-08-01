VERSION="0.0.4"

class Fauxrest < Formula
  desc "Pseudo-REST static API generator"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/fauxrest"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.4/fauxrest-0.0.4_amd64_darwin.tar.gz"
    sha256 "56a14411e4ad5298dcee47e2a1ddb3c3e4bfe92285eeb901ad6479e2f8994b49"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.4/fauxrest-0.0.4_amd64_linux.tar.gz"
    sha256 "509491451fd65b4105fe413f792f20774258f52e5aceef0ba65711b518bc2065"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.4/fauxrest-0.0.4_arm64_darwin.tar.gz"
    sha256 "790c09a91a2bc40d7e36b2d1a62e5ea1beea4f64f79f16620842688465f0435a"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.4/fauxrest-0.0.4_arm64_linux.tar.gz"
    sha256 "438d83ca61647c9105602c0095f5ef6641d7dc5938ffe5daa83b9e61aeb8c340"
  end

  def install
    bin.install "fauxrest"

    bash_completion.install "completions/bash/fauxrest" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_fauxrest" if build.with? "completions"
    fish_completion.install "completions/fish/fauxrest" if build.with? "completions"
  end

  test do
    system "#{bin}/fauxrest --version"
  end
end
