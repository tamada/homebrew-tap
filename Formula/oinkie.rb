VERSION="0.6.0"

class Oinkie < Formula
  desc "The software birthmark toolkit for real-world executables"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/oinkie"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.6.0/oinkie-0.6.0_amd64_darwin.tar.gz"
    sha256 "c94a7f3c7f6a6ee4871381e8bfaa8e3f3b9f181264f3d60628422caa0e4edada"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.6.0/oinkie-0.6.0_amd64_linux.tar.gz"
    sha256 "0b06636a44bb325d9ab6c7062bcc8d46bd7c394ebfb757a0b1df96cc2c2f27f2"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.6.0/oinkie-0.6.0_arm64_darwin.tar.gz"
    sha256 "a2e46118f3d6d0684ace302181cd723fc8c99047e4fad7561c28505ed93293c4"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.6.0/oinkie-0.6.0_arm64_linux.tar.gz"
    sha256 "51bd9b13722e4c56641648b505264ac6cf89d97bc18e39a2e2808a938cf2aa6a"
  end

  def install
    bin.install "oinkie"

    bash_completion.install "completions/bash/oinkie" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_oinkie" if build.with? "completions"
    fish_completion.install "completions/fish/oinkie.fish" if build.with? "completions"
  end

  test do
    system "#{bin}/oinkie --version"
  end
end
