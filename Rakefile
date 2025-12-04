# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/extensiontask"

task build: :compile

GEMSPEC = Gem::Specification.load("cocoafile.gemspec")

Rake::ExtensionTask.new("cocoafile", GEMSPEC) do |ext|
  ext.lib_dir = "lib/cocoafile"
end

task default: %i[clobber compile]
