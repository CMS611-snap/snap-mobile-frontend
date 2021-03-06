$ ->
  if window.location.search.indexOf("local") != -1
      socket = io.connect('http://localhost:8080', {secure: false})
  else
      socket = io.connect('https://snapgame.herokuapp.com:443', {secure: true})
  socket.emit 'new player', "testing"

  wordCount = 0
  wordsMap  = {} # word -> number
  scoreMap  = {} # word -> snaps number
  score     = 0

  $('#submitWord').click ->
    if wordCount < 5
      word = $('#wordInput').val()
      unless wordsMap[word]
        wordCount++
        socket.emit 'new word', word

        $("#word#{wordCount}").text(word)
        wordsMap[word] = wordCount

  socket.on 'snap', (data) ->
    console.log "snap!"
    console.log data
    snappedWord = data.word
    wordNumber  = wordsMap[snappedWord]

    if scoreMap[snappedWord]
      scoreMap[snappedWord] += data.d_score
      score += data.d_score
    else
      scoreMap[snappedWord] = data.d_score
      score += 1

    $("#word#{wordNumber}").css('color', 'green')
    $("#score#{wordNumber}").text("+" + scoreMap[snappedWord])
    $("#totalScore").text(score)
