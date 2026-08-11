VERSION="0.8.16"

class Totebag < Formula
  desc "A tool for archiving files and directories and extracting several archive formats."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/totebag"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.8.16/totebag-0.8.16_darwin_amd64.tar.gz"
    sha256 "57084889fff074d00b3ada8e5ad502bf04b355db2343aec6a26a69bf7412d456"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.8.16/totebag-0.8.16_darwin_arm64.tar.gz"
    sha256 "09c80a6059766987f8876d34e33464dc0834d4ce8ab8eb8a1b1543b3dbd42182"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.8.16/totebag-0.8.16_linux_amd64.tar.gz"
    sha256 "4c0c41aa825fc3cd3054ec346107294b1be60bbd854df1f5250c567c35758da3"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.8.16/totebag-0.8.16_linux_arm64.tar.gz"
    sha256 "f75ca77d4183d8a7cb50cc0beeb9261e866b5a2157d36b14163f542da28c626d"
  end

  def install
    bin.install "totebag"

    bash_completion.install "assets/completions/bash/totebag" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_totebag" if build.with? "completions"
    fish_completion.install "assets/completions/fish/totebag" if build.with? "completions"
  end

  test do
    system "#{bin}/totebag --version"
  end
end
