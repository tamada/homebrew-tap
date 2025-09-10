VERSION="{{ release.tagName | to_version }}"

class Btmeister < Formula
  desc "Detecting the build tools in use"
  homepage "https://github.com/{{ project.owner }}/{{ project.name }}"
  version VERSION
  license "{{ project.license }}"

  {%- for asset in release.assets %}
    {%- if "darwin" in asset.name and "amd64" in asset.name %}
  if OS.mac? && Hardware::CPU.intel?
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
    {%- endif %}
    {%- if "darwin" in asset.name and "arm64" in asset.name %}
  if OS.mac? && Hardware::CPU.arm?
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
    {%- endif %}
    {%- if "linux" in asset.name and "amd64" in asset.name %}
  if OS.linux? && Hardware::CPU.intel?
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
    {%- endif %}
    {%- if "linux" in asset.name and "arm64" in asset.name %}
  if OS.linux? && Hardware::CPU.arm?
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
    {%- endif %}
  {%- endfor %}

  option "without-completions", "Disable bash completions"
  depends_on "rustup" => :build
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "btmeister"
    prefix.install "README.md"
    prefix.install "LICENSE"

    bash_completion.install "assets/completions/bash/btmeister" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_btmeister" if build.with? "completions"
    fish_completion.install "assets/completions/fish/btmeister" if build.with? "completions"
  end
end
