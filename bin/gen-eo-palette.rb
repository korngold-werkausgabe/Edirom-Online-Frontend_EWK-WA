#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Regenerate packages/eoTheme/sass/etc/eo-palette.scss from the canonical CSS
# custom properties in resources/css/eo-palette.css.
#
# Run automatically by build.xml (target "-before-sass"); also safe to run by
# hand after editing eo-palette.css.  The .scss is committed but generated —
# do not edit it directly.
#
# Every "--eo-<name>: <value>;" custom property becomes "$eo-<name>: <value> !default;".
# <value> is copied verbatim (whitespace/newlines collapsed) so any CSS colour
# syntax works: #hex, rgb()/rgba(), hsl()/hsla(), named colours, etc. — Sass
# evaluates it, and the theme's darken()/lighten()/mix() calls operate on it.
# A trailing /* ... */ comment on the same line is carried over as a // comment.

root = File.expand_path('..', __dir__)
src  = File.join(root, 'resources', 'css', 'eo-palette.css')
out  = File.join(root, 'packages', 'eoTheme', 'sass', 'etc', 'eo-palette.scss')

abort "gen-eo-palette: missing #{src}" unless File.file?(src)

css = File.read(src, encoding: 'UTF-8')
# ignore the file header comment / selector — start at the first "{"
body = css.sub(/\A.*?\{/m, '')

tokens = body.scan(%r{
    --(eo-[A-Za-z0-9_-]+)          # 1: name
    \s*:\s*
    ([^;{}]+?)                     # 2: value
    \s*;
    [^\S\n]*                       # trailing spaces/tabs on the same line
    (?: /\* \s* (.*?) \s* \*/ )?   # 3: optional trailing block comment
}xm).map do |name, value, comment|
  decl = "$#{name}: #{value.gsub(/\s+/, ' ').strip} !default;"
  note = comment && comment.gsub(/\s+/, ' ').strip
  note && !note.empty? ? "#{decl}  // #{note}" : decl
end

abort "gen-eo-palette: no --eo-* custom properties found in #{src}" if tokens.empty?

File.write(out, <<~SCSS)
  // AUTO-GENERATED from resources/css/eo-palette.css - do not edit.
  // Change the colours in that .css file; build.xml regenerates this before
  // every Sass compile (or run `ruby bin/gen-eo-palette.rb` by hand).

  #{tokens.join("\n")}
SCSS

warn "gen-eo-palette: wrote #{tokens.length} token(s) to #{out.sub("#{root}/", '')}"
