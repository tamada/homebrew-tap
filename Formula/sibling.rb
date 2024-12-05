VERSION="v2.0.0-beta-3"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  version VERSION
  license "WTFPL License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-3/sibling-2.0.0-beta-3_darwin_amd64.tar.gz"
    sha256 "b2233ffa0642e52c293affee78e1bb7090c433c9ab330a078d58993528d42c73"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-3/sibling-2.0.0-beta-3_darwin_arm64.tar.gz"
    sha256 "295b01b5b1026b3dd9e06412c054b5e22843524f7260292e673b116e9fe2fa8e"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-3/sibling-2.0.0-beta-3_linux_amd64.tar.gz"
    sha256 "75fba5964c1438206372f034c8f043f5130f49ed68e8b775b7b2a161ef6c2104"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-3/sibling-2.0.0-beta-3_linux_arm64.tar.gz"
    sha256 "26e33d6bd961997454d3eff8eadc6d0c24fc02cdd695b732c0b5023f81eb0325"
  end


  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end

  test do
    system "#{bin}/sibling --version"
  end
end
