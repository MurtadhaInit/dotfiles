require('lazy').setup({
  {
    'echasnovski/mini.surround',
    version = '*',
    config = function ()
      require('mini.surround').setup()
    end
  }
})