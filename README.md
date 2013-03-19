# R2

A ruby library for making arbitrary translations to CSS stylesheets. Its primary use case is creating mirror-images of stylesheets for use with [right-to-left languages](http://en.wikipedia.org/wiki/Right-to-left) like Arabic or Hebrew.

Originally inspired by the Javascript/Node [R2](https://github.com/ded/R2) project.

## Installation

    $ gem install r2

## Usage

### Convert a stylesheet to right-to-left

You can use the handy static method for flipping any CSS string via:

```ruby
> R2.r2("body { direction: rtl; }")
#=> "body { direction: ltr; }"
```

### Apply arbitrary translations to a stylesheet

R2 also provides a simple DSL for defining your own custom translations:

```ruby
# Convert to the Queen's CSS
R2.translate(css) do

  match :property => /\bcolor\b/ do
    property.gsub!('color', 'colour')
  end

  match :property => /\bz-index\b/ do
    property.gsub!('z-index', 's-index')
  end

  match :value => /\bgray\b/ do
    value.gsub!('gray', 'grey')
  end

  match :value => /url[\s]*\([\s]*([^\)]*)[\s]*\)[\s]*/ do
    value.gsub!('burger.jpg', 'nice-cup-of-tea.jpg')
  end

end
```

### Mix and match
`R2.r2` will also accept a block allowing you to define additional translations:

```ruby
# Convert a stylesheet to RTL and convert any urls containing `-ltr.png` to `-rtl.png`
R2.r2(css) do
  match :value => /url[\s]*\([\s]*([^\)]*)[\s]*\)[\s]*/ do
    value.gsub!('-ltr.png', '-rtl.png')
  end
end
```

## Change Log

 * v0.1.0 – [@fractious](https://github.com/fractious) updates
   * [CLEANUP] Added rspec dev dependency
   * [CLEANUP] Fixed typo in internal method name
   * [FEATURE] Added support for background-position
 * v0.0.3 - Feature release
   * [FEATURE] Added -moz and -webkit border support
   * [FEATURE] Added box-shadow (+moz and webkit) support
   * [DOC] Added change log
 * v0.0.2 - Documentation updated
 * v0.0.1 - Initial release

## Copyright and License

     Copyright 2011 Twitter, Inc.

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this work except in compliance with the License.
     You may obtain a copy of the License in the LICENSE file, or at:

       http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
