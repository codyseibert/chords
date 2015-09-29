gulp = require 'gulp'
browserify = require 'gulp-browserify'
clean = require 'gulp-clean'
del = require 'del'
livereload = require 'gulp-livereload'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
jade = require 'gulp-jade'
sass = require 'gulp-sass'
connect = require 'gulp-connect'

gulp.task 'copy', ->
  gulp.src(['index.html', 'chords.jpg'])
    .pipe gulp.dest('dist')
    .pipe connect.reload()

gulp.task 'watch', ->
  gulp.watch 'index.html', [
    'copy'
  ]

gulp.task 'connect', ->
  connect.server
    root: 'dist'
    livereload: true

gulp.task 'default', [
  'connect'
  'watch'
]
