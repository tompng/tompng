​<!-- run(`ruby README.md`).to_update
BEGIN {
    pattern = /<!-{2} EMBED: ((?<path>[\w.\/]+)|`(?<command>[^`]+)`) -{2}>(\n?```+(?<type>\w*)(\n|([^`\n]|`[^`\n]|``[^`\n])[^\n]*\n)*```\n)?/
  markdown = File.read(__FILE__).gsub pattern do |text|
    match = pattern.match text
    [
      "<!#{'-' * 2} EMBED: #{match[:path] || "`#{match[:command]}`"} #{'-' * 2}>",
      "```#{match[:type]}",
      (match[:path] ? File.read(match[:path]) : `#{match[:command]}`).gsub(/\n\z/, ''),
      '```'
    ].join("\n") + "\n"
  end
  File.write __FILE__, markdown
  exit
}
__END__
-->

# Self Introduction Code

<!-- EMBED: tompng_simple.rb -->
```ruby
```

<!-- EMBED: `ruby tompng_simple.rb` -->

<!-- EMBED: tompng.rb -->
```ruby
```

<!-- EMBED: `ruby tompng_static.rb` -->
