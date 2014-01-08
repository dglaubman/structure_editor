class Histogram
  threshold = 100
  numBuckets = 100

  constructor: (@limit, @statistic) ->
    @counter = 0
    @bucketSize = Math.max 1, Math.ceil(limit/numBuckets)
    @currentYear = 0
    @buckets = ( 0 for i in [1..numBuckets] )


  process: (v) ->
    @statistic.observe v
    if ++@counter % threshold is 0
      p = @buckets.map

