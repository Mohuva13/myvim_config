#Check Internet connection
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  echo "Downloading data..."
else
  echo "Please check your internet connection and try again."
  exit
fi


function progress() {
    echo -ne "Please wait...\n"
    while true
    do
        echo -n "#"
        sleep 2
    done
}

function installer() {
  #Set some vim option in ~/.vimrc

  set_option=('set hlsearch' 'syntax on' 'set background=dark' 'colorscheme hybrid_material' 'set number' 'set mouse=a' 'set titlestring=%t' 'set title' 'set ruler' 'set confirm' 'set spell')
  len_set_option=${#set_option[@]}+1

  function setter() {
    for ((i = 1; i < len_set_option; i++)); do
      echo "${set_option[i]}" >>~/.vimrc
    done
  }

  config_file=~/.vimrc
  if [[ -f "$config_file" ]]; then
    rm ~/.vimrc
    touch ~/.vimrc
    setter
  else
    touch ~/.vimrc
    setter
  fi

  #Install 'The NERDTree' plugin, vim-hybrid-material  and dependency
  #https://github.com/preservim/nerdtree
  #https://github.com/kristijanhusak/vim-hybrid-material

  mkdir -p ~/.vim/autoload ~/.vim/bundle &&
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  vim_bundle_path=~/.vim/bundle/vim-sensible/
  if [ -d "$vim_bundle_path" ]; then rm -Rf $vim_bundle_path; fi

  cd ~/.vim/bundle &&
    git clone https://github.com/tpope/vim-sensible.git >/dev/null 2>&1

  nerdtree_path=~/.vim/bundle/nerdtree
  if [ -d "$nerdtree_path" ]; then rm -Rf $nerdtree_path; fi

  git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree >/dev/null 2>&1
  nerdtree_command_list=('execute pathogen#infect()' 'call pathogen#infect()' 'filetype plugin indent on' 'nnoremap <leader>n :NERDTreeFocus<CR>' 'nnoremap <C-n> :NERDTree<CR>' 'nnoremap <C-t> :NERDTreeToggle<CR>' 'nnoremap <C-f> :NERDTreeFind<CR>' 'autocmd VimEnter * NERDTree | wincmd p')
  len_nerdtree_command_list=${#nerdtree_command_list[@]}+1

  for ((j = 1; j < len_nerdtree_command_list; j++)); do
    echo "${nerdtree_command_list[j]}" >>~/.vimrc
  done

  git clone https://github.com/kristijanhusak/vim-hybrid-material ~/.vim/bundle/vim-hybrid-material >/dev/null 2>&1
  cp -r ~/.vim/bundle/vim-hybrid-material/colors/ ~/.vim >/dev/null 2>&1

  function set_plugin() {
    vim -c ':Helptags' 1>/dev/null 2>/dev/null
  }
  set_plugin &
  mySelfID=$!
  kill $mySelfID >/dev/null 2>&1
}

progress &
selfID=$!
installer
kill $selfID >/dev/null 2>&1
echo " \n Finished :) "
exit
