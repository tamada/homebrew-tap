VERSION="{{ release.tagName | to_version }}"

class Heatman < Formula
  desc "Creating heat map from given csv file."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/{{ project.owner }}/{{ project.name }}"
  version VERSION
  license "{{ project.license }}"

  {%- for asset in release.assets %}
    {%- set condition = "" -%}
    {%- if "darwin" in asset.name and "amd64" in asset.name %}
      {%- set condition = "  if OS.mac? && Hardware::CPU.intel?" -%}
    {%- endif %}
    {%- if "darwin" in asset.name and "arm64" in asset.name %}
      {%- set condition = "  if OS.mac? && Hardware::CPU.arm?" -%}
    {%- endif %}
    {%- if "linux" in asset.name and "amd64" in asset.name %}
      {%- set condition = "  if OS.linux? && Hardware::CPU.intel?" -%}
    {%- endif %}
    {%- if "linux" in asset.name and "arm64" in asset.name %}
      {%- set condition = "  if OS.linux? && Hardware::CPU.arm?" -%}
    {%- endif %}

    {%- if condition != "" %}
{{ condition }}
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
    {%- endif %}
  {%- endfor %}

  def install
    bin.install "heatman"

    bash_completion.install "completions/bash/heatman" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_heatman" if build.with? "completions"
    fish_completion.install "completions/fish/heatman" if build.with? "completions"
  end

  test do
    system "#{bin}/heatman --version"
  end
end
