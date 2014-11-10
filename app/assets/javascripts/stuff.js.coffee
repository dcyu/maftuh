jQuery ->
  $(".message_text").each ->
    html = $(this).html()
    $(this).html html.replace("@testmaftuh", '<a href="https://www.twitter.com/testmaftuh" target="_blank">@testmaftuh</a>')
    return