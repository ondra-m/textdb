# Textdb

Textdb is a database which structure is determined by folders and data are represented by files.

Current state: **beta version**.

Example:
```ruby
# .
# |-- key1
# |   |-- key1_1
# |   |   `-- value1_1_1.data
# |   `-- value1_1.data
# `-- key2
#     `-- value2_1.data

{
  'key1' => {
    'key1_1' => { 
      'value1_1_1' => 'text'
    },
    'value1_1_1' => 'text'
  },
  'key2' => {
    'value2_1' => 'text'
  }
}

```

## Installation

Add this line to your application's Gemfile:

```
gem 'text-db'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install text-db
```

## Configuration

`Textdb.config` or `Textdb.configuration(&block)`.

How:
```ruby
Textdb.configuration do
  key "/tmp/1"
end

# --- OR ---

Textdb.config.key = "/tmp/1"
```

<table>
  <thead>
    <tr>
      <th>Key</th>
      <th>Default</th>
      <th>Description</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td><b>base_folder</b></td>
      <td>/tmp/textdb</td>
      <td>The root folder for Textdb. Folder must exist.</td>
    </tr>
    <tr>
      <td><b>data_file_extension</b></td>
      <td>.data</td>
      <td>Extension for data files.</td>
    </tr>
    <tr>
      <td><b>listen</b></td>
      <td>false</td>
      <td>Automatic listening for changes in the root folder</td>
    </tr>
  </tbody>
</table>

## Usage

Folder structure:
```
.
|-- key1
|   |-- key1_1
|   |   `-- key1_1_1
|   |       |-- value1_1_1_1
|   |       `-- value1_1_1_2
|   |-- value1_1
|   `-- value1_2
`-- key2
    `-- value2_1
```

### Read

```ruby
Textdb.read { key1 }           # -> list of all in the folder /key1
Textdb.read { key2.value2_1 }  # -> content of file /key2/value2_1.data
```

### Create

```ruby
Textdb.create { a.b.c }                  # -> create a file /a/b/c.data
Textdb.create { a.b.c }.update("text")   # -> create a file /a/b/c.data with content "text"
```

### Update

`\n` is not included at the end.

```ruby
Textdb.update("text") { a.b.c }   # -> update /a/b/c.data with new content
```

### Delete

```ruby
Textdb.delete { key1 }            # -> delete everything in the folder /key1
Textdb.delete { key2.value2_1 }   # -> delete only /key/value2_1.data
```

## Listen

If **listen** is true.

```ruby
Textdb.read { a.b }   # -> "text"

# On FS -------------------------
File.open('/a/b.data', 'w') { |f| 
  f.write('text 2')
}
# -------------------------------

Textdb.read { a.b }   # -> "text 2"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
