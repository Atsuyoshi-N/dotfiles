function! EnableJavascript()
  let g:used_javascript_libs = 'jquery,underscore,angularjs,angularui,angularuirouter,react,flux,jasmine,d3,vue'

  let b:javascript_lib_use_jquery          = 1
  let b:javascript_lib_use_underscore      = 1
  let b:javascript_lib_use_angularjs       = 1
  let b:javascript_lib_use_angularui       = 1
  let b:javascript_lib_use_angularuirouter = 1
  let b:javascript_lib_use_react           = 1
  let b:javascript_lib_use_flux            = 1
  let b:javascript_lib_use_jasmine         = 1
  let b:javascript_lib_use_d3              = 1
  let b:javascript_lib_use_vue             = 1
endfunction

autocmd MyAutoCmd FileType javascript call EnableJavascript()

