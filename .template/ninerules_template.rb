VERSION="1.1.0"

class Ninerules < Formula
  desc "Checking tool of small object programming for the Java language"
  homepage "https://github.com/tamada/9rules"
  url "https://github.com/tamada/9rules/releases/download/v#{VERSION}/9rules-#{VERSION}-bin.zip"
  version VERSION
  sha256 "c4e27c371ff2f52e51998752b29db6a061dc6e813306d66547b67822cf05ba34"

  def install
    (bin/"9rules").write <<~EOS
      #!/bin/sh
      java -jar #{prefix}/9rules-#{VERSION}.jar "$@"
    EOS
    prefix.install "9rules-#{VERSION}.jar"
    prefix.install "lib"
    prefix.install "bin"
  end
end
