{% set r = release %}
VERSION="{{ r.tag_name }}"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/{{ project.owner }}/{{ project.name }}"
  version VERSION
  license "{{ project.license }}"

  {% set DARWIN_AMD64 = "" %}
  {% set DARWIN_ARM64 = "" %}
  {% set LINUX_AMD64 = "" %}
  {% set LINUX_ARM64 = "" %}
  {% for asset in r.assets %}
    {% if "darwin" in asset.name and "amd64" in asset.name %}
      {% set DARWIN_AMD64 = asset.url %}
    {% endif %}
    {% if "darwin" in asset.name and "arm64" in asset.name %}
      {% set DARWIN_ARM64 = asset.url %}
    {% endif %}
    {% if "linux" in asset.name and "amd64" in asset.name %}
      {% set LINUX_AMD64 = asset.url %}
    {% endif %}
    {% if "linux" in asset.name and "arm64" in asset.name %}
      {% set LINUX_ARM64 = asset.url %}
    {% endif %}
  {% endfor %}

  {% if DARWIN_AMD64 %}
  if OS.mac? && Hardware::CPU.intel?
    url "{{ DARWIN_AMD64 }}"
    sha256 "{{ DARWIN_AMD64 | sha256 }}"
  end
  {% endif %}

  {% if DARWIN_ARM64 %}
  if OS.mac? && Hardware::CPU.arm?
    url "{{ DARWIN_ARM64 }}"
    sha256 "{{ DARWIN_ARM64 | sha256 }}"
  end
  {% endif %}

  {% if LINUX_AMD64 %}
  if OS.linux? && Hardware::CPU.intel?
    url "{{ LINUX_AMD64 }}"
    sha256 "{{ LINUX_AMD64 | sha256 }}"
  end
  {% endif %}

  {% if LINUX_ARM64 %}
  if OS.linux? && Hardware::CPU.arm?
    url "{{ LINUX_ARM64 }}"
    sha256 "{{ LINUX_ARM64 | sha256 }}"
  end
  {% endif %}


  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end

  test do
    system "#{bin}/sibling --version"
  end
end
