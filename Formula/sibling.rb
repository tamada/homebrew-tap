VERSION="v2.0.3"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  version VERSION
  license "WTFPL License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v2.0.3/sibling-2.0.3_darwin_amd64.tar.gz"
    sha256 "639f7d2b3ae2f29a58f7395af44eef060ae188255eee3735972139f975f2135b"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v2.0.3/sibling-2.0.3_darwin_arm64.tar.gz"
    sha256 "0065c348d10c8d31b753386c5b87f3da6303ddbe4b6039bd1bf3b81a19e3c2c8"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v2.0.3/sibling-2.0.3_linux_amd64.tar.gz"
    sha256 "f33b5417b09f381744333ac0572cbd9f0f36a04e6dfa40a8b4fc18ef018a22bb"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v2.0.3/sibling-2.0.3_linux_arm64.tar.gz"
    sha256 "162f49cc55b79df1acfdec34aec6b5f92b2b252a2097884a59b009c72500c923"
  end

  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end

  test do
    system "#{bin}/sibling --version"
  end
end
