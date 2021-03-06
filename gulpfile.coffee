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
brass = require 'gulp-brass'
rimraf = require 'rimraf'
path = require 'path'
fs = require 'fs'
semver = require 'semver'

getPackageJson = ->
  JSON.parse fs.readFileSync('./package.json', 'utf8')

json = getPackageJson()
version = json.version
major = semver.major version
minor = semver.minor version
patch = process.env.BUILD_NUMBER or semver.patch version

options =
    name: 'chords'
    version: "#{major}.#{minor}.#{patch}"
    license: 'MIT'
    summary: 'Chords App'
    description: 'Used to Quickly Generate Guitar Chords'

rpm = brass.create(options)

gulp.task 'clean', (callback) ->
  rimraf rpm.buildDir, callback
  return

gulp.task 'rpm-setup', [ 'clean' ], rpm.setupTask()

gulp.task 'rpm-files', [
  'rpm-setup'
], ->
  globs = [
    'dist/**/*'
  ]
  gulp.src(globs)
    .pipe(gulp.dest(path.join(rpm.buildRoot, '/var/www/html/chords')))
    .pipe rpm.files()

gulp.task 'rpm-spec', [
  'rpm-files'
], rpm.specTask()

gulp.task 'rpm-build', [
  'rpm-setup'
  'rpm-files'
  'rpm-spec'
], rpm.buildTask()

gulp.task 'build', [ 'copy', 'rpm-build' ], ->
  console.log 'build finished'
  return

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
