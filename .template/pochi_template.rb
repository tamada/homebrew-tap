{{- $r := .Release -}}
VERSION="{{ $r.TagName }}"
{{- $release := findAsset $r "zip" -}}

class Pochi < Formula
  desc "Java birthmark toolkit, detecting the software theft by native characteristics of the programs."
  homepage "https://tamada.github.io/pochi"

  url "{{ r.Assets[0].URL }}"
  sha256 "{{ sha256 r.Assets[0].URL }}"

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
