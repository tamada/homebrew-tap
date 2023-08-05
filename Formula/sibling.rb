VERSION="1.3.0"
PRODUCT="sibling"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  version VERSION
  license "WTFPL"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}_darwin_amd64.tar.gz"
    sha256 "57a1c8231290b34e43fd4bcba01c17a0abcc8f62fcab708c323f01463a73cac9"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}_darwin_arm64.tar.gz"
    sha256 "1a4ef68c4ed4ccb43f4dedfb730eda08fde402d9fb47e19fc6f09e4f636f1698"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}_linux_amd64.tar.gz"
    sha256 "7e4bcc19151499e857eb28fcf9f89648f6f97ccde26e48cd18a3823ab99c21ad"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}_linux_arm64.tar.gz"
    sha256 "5adbd8b33d468bae3a6a0807da49fe02c45ded01e67d82390d05819d4d7d950d"
  end

  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end

  test do
    system "#{bin}/sibling --version"
  done
end
