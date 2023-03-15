
vec_files <- list.files("code/2023/")

vec_files <- vec_files[str_detect(vec_files, pattern = "0")] 

vec_files <- vec_files[order(vec_files)]

vec_files

for (i in vec_files) {
  path_file = paste0("code/2023/", vec_files)
  source(path_file)
  print(i)
}

