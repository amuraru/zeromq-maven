#!/bin/bash

find ./repository -depth -name '* *' \
| while IFS= read -r f ; do mv -i "$f" "$(dirname "$f")/$(basename "$f"|tr -d " ")" ; done

for DIR in $(find ./repository -type d); do
  (
    echo -e "<html>\n<body>\n<h1>Directory listing</h1>\n<hr/>\n<pre>"
    ls -1pa "${DIR}" | grep -v "^\./$" | grep -v "^index\.html$" | awk '{ printf "<a href=\"%s\">%s</a>\n",$1,$1 }'
    echo -e "</pre>\n</body>\n</html>"
  ) > "${DIR}/index.html"
done


#Convert README.md to index.md (required for gh-pages index)
cat <<'EOF' | ruby
path = `pwd`.gsub(/\n/, "")
readme_path = File.join(path, "README.md")
index_path = File.join(path, "index.md")

# write the index readme file
File.open readme_path, "r" do |readme|
  File.open index_path, "w" do |index|

    # write the jekyll front matter
    index.puts "---"
    index.puts "layout: main"
    index.puts "---"

    readme.readlines.each do |line|

      # convert backticks to liquid
      %w(bash ruby xml java js).each do |lang|
        line.gsub!("```#{lang}", "{% highlight #{lang} %}")
      end
      line.gsub!("```", "{% endhighlight %}")

      index.puts line
    end
  end
end
EOF

