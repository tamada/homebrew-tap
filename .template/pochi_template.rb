{%- set r = release %}
VERSION="{{ r.tagName }}"
{%- set release = r.assets | filter(attribute="name", value="zip") | first %}

class Pochi < Formula
  desc "Java birthmark toolkit, detecting the software theft by native characteristics of the programs."
  homepage "https://tamada.github.io/pochi"

  url "{{ r.url }}"
  sha256 "{{ r.url | sha256 }}"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    prefix.install "data"
    prefix.install "docs"
    prefix.install "dockers"
    prefix.install "examples"
    prefix.install "lib"
    prefix.install "LICENSE"
    prefix.install "README.md"

    bin.install "bin/pochi"

    bash_completion.install "completions/bash/pochi" if build.with? "completions"
    zsh_completion.install "completions/zsh/pochi" if build.with? "completions"
  end

  def caveats
    <<~EOS
      The examples are available in the #{prefix}/examples
    EOS
  end
end
