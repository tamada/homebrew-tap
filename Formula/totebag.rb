VERSION="0.1.15"
PRODUCT="totebag"

class Totebag < Formula
  desc "A tool for archiving files and directories and extracting several archive formats."
  homepage "https://github.com/tamada/totebag"
  version VERSION
  license "MIT"

  option "without-completions", "Disable completions"
  depends_on "bash-completion@2" => :optional

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}_darwin_amd64.tar.gz"
    sha256 "0fc84ded2d5a630c5d6c18781e96c03156e81e5be06a214cf018d46866bbe37c"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}_darwin_arm64.tar.gz"
    sha256 "231d31f06856146b6cee6829e577a8e89f178b522829aa725a3c6ad73b14dac0"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}_linux_amd64.tar.gz"
    sha256 "8a6ca11f56e2f24f5de0fd853d80e6e735bd76dd6985cecc6dd3257c1473f46a"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}_linux_arm64.tar.gz"
    sha256 "8f84ea88797ad7e1b6f872be227211da2722c31c1a8b7acc80079028631c922c"
  end

  def install
    bin.install "totebag"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
    fish_completion.install "completions/fish/sibling.bash" if build.with? "completions"
    zsh_completion.install  "completions/zsh/sibling.bash"  if build.with? "completions"
  end

  test do
    system "#{bin}/totebag --version"
  end
end
