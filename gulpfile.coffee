gulp       = require 'gulp'
watch      = require 'gulp-watch'
livereload = require 'gulp-livereload'
browserify = require 'browserify'
nodemon    = require 'gulp-nodemon'
source     = require 'vinyl-source-stream'

gulp.task 'coffee', ->
  browserify
    entries: ['./src/main.coffee']
    extensions: ['.coffee', '.js']
    debug: true
  .transform 'coffeeify'
  .bundle()
  .pipe source 'main.js'
  .pipe gulp.dest 'public/javascripts'

gulp.task 'watch', ->
  gulp.watch './src/*.coffee', ['coffee']
      .on 'change', livereload.changed

gulp.task 'develop', ->
  livereload.listen()
  nodemon {script: './bin/www', ex: 'js html'}
    .on 'start', ['watch']
    .on 'restart', ->
      console.log 'restart server'

gulp.task 'default', ['coffee', 'develop']
