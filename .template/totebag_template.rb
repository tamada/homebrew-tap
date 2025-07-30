{% set r = project.release %}
VERSION="{{ r.tag_name | to_version }}"

class Totebag < Formula
  desc "{{ project.description }}"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/{{ project.repo_name }}"
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
    bin.install "{{ project.name }}"

    bash_completion.install "assets/completions/bash/{{ project.name }}" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_{{ project.name }}" if build.with? "completions"
    fish_completion.install "assets/completions/fish/{{ project.name }}" if build.with? "completions"
  end

  test do
    system "#{bin}/{{ project.name }} --version"
  end
end
