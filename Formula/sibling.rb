VERSION="v2.0.2"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  version VERSION
  license "WTFPL License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v2.0.2/sibling-2.0.2_darwin_amd64.tar.gz"
    sha256 "6f1588cee3bf383a8536279958820259a25f744732e9efaf2884b795729ab836"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v2.0.2/sibling-2.0.2_darwin_arm64.tar.gz"
    sha256 "929834328b4ebc48da50c69af425add44dd5f1e1c80a3ffd35cda50730ebc541"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v2.0.2/sibling-2.0.2_linux_amd64.tar.gz"
    sha256 "7fd99726a3f74ecabeee126f84e3023ba548f1f430c94afa6b1ed3aafce8880c"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v2.0.2/sibling-2.0.2_linux_arm64.tar.gz"
    sha256 "4943720882e09f4e49b9a33bd1f7dfce99599e87b0de6466dd96d4fe595f47a4"
  end


  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end

  test do
    system "#{bin}/sibling --version"
  end
end
