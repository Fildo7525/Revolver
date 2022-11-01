# Revolver

Revolver is a small plugin that saves opened files on exit and reloads them on another session. There is also a support for multiple projects.

## Instalation

```use "Fildo7525/Revolver"```

## Usage

The usage is simple. There are two functions.
 - SaveOpenedFiles()
 - OpenSavedFiles(boolean)

### SaveOpenedFiles

As the name sais the revolver saves the fullpaths to a file. The filename is deduced from the project Location. So there should not be an occurance of overwriting the files.

### OpenSavedFiles

Opens the files saved in the list. The parameter contorls, whether the file containing the names of the files should be deleted or not.

You can use keymaps like these to save some time:

```
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("n", "<leader>wq", ":lua require('revolver').SaveOpenedFiles()<CR> | :wq<CR>", opts)
keymap("n", "<leader>lf", ":lua require('revolver').OpenSavedFiles()<CR>", opts)
```

