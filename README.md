# Snippy

Snippy is a linux snippet manager with powerfull features !

![snippy](img/snippy.png)

## Features

### Clipboard

* Restore current clipboard after pasting the snippet
* `{clipboard}` placeholder to use current clipboard in snippet, ex:
```
CREATE DATABASE \`{clipboard}\` CHARACTER SET utf8 COLLATE utf8_general_ci;
```
* `{clipboard_urlencode}` placeholder to use current clipboard in snippet with urlencode format, ex:
```
https://cachedview.nl/#{clipboard_urlencode}
```

### Cursor

`{cursor}` placeholder to place the cursor

* go left to the correct position for cli and gui paste
  ```
  <pre>{cursor}</pre>
  ```

* go up for block snippet for gui paste
  ```
  <pre>
    {cursor}
  </pre>
  ```

### Parsing
* `##noparse` header in snippet to not parse/execute the snippet.
    ```
    ##noparse
    date --date="$(date +%F) -1 month" +%F
    ```
* directly execute command begining by `$`
* execute bash script in `$snippets_directory/scripts`
* copy script content when selection is selected by CTRL+Return, exemple:
  - with the following snippet: `$(date +%Y-%m-%d-%Hh%Mm%S)`
  - using Return will paste the current date
  - using CTRL+Return will paste the command directly
  

### Icons !

Icon name is set in rofi with the root directory name of your snippets.

If you have the following snippets, the `terminal` icon will be displayed in rofi:
```
    terminal/
    ├── other/
    │   └── date
    └── script/
        └── test
```

![icons](img/icons.png)
