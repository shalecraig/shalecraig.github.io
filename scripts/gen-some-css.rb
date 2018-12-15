#!/usr/local/bin/ruby -w

COLORS = {
  a: '#7795f8',
  b: '#45b2e8',
  c: '#3ecf8e',
  d: '#d782d9',
  e: '#f79a59',
  f: '#fa755a',
  g: '#a78ce9',
}
x = COLORS.keys
def to_css(a, b)
  color_a = COLORS[a]
  color_b = COLORS[b]
  <<~CSS
    .sample-schedule .oncall-#{a}-to-#{b} {
      background-image:
        linear-gradient(
          to bottom right,
          #{color_a},
          #{color_a} 50%,
          #{color_b} 50%
        );
    }
  CSS
end
y = x.flat_map do |a|
  results = x.map do |b|
    next if a == b
    to_css(a, b)
  end
  default = <<~CSS
    .sample-schedule .oncall-#{a} {
      background-color: #{COLORS[a]};
      color: #{COLORS[a]};
    }
  CSS
  results + [default]
end.compact.join("\n")

File.open('assets/GENERATED-oncall.css', 'w') { |file| file.write(y) }

