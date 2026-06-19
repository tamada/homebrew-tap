VERSION="{{ release.tagName }}"

class Peripherals < Formula
  desc "peripheral utility commands for the shell."
  homepage "https://github.com/{{ project.owner }}/{{ project.name }}"
  version VERSION
  license "{{ project.license }}"

  {%- for asset in release.assets %}
    {%- if "darwin" in asset.name and "amd64" in asset.name %}
  if OS.mac? && Hardware::CPU.intel?
    {%- endif %}
    {%- if "darwin" in asset.name and "arm64" in asset.name %}
  if OS.mac? && Hardware::CPU.arm?
    {%- endif %}
    {%- if "linux" in asset.name and "amd64" in asset.name %}
  if OS.linux? && Hardware::CPU.intel?
    {%- endif %}
    {%- if "linux" in asset.name and "arm64" in asset.name %}
  if OS.linux? && Hardware::CPU.arm?
    {%- endif %}
    url "{{ asset.url }}"
    sha256 "{{ asset.url | sha256 }}"
  end
  {%- endfor %}

  def install
    bin.install "bin/ptest"
    bin.install "bin/puniq"
    bin.install "bin/ptake"
    bin.install "bin/pskip"
    bin.install "bin/snip"
  end
end
