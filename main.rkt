#lang racket
(provide redis%)

(require "resp.rkt" "client.rkt" racket/tcp)

#;(define (new-redis in port timeout)
  (let ([client (new tcp-client% ip port timeout)])
    (new redis% client)))

(define redis%
  (class
      object%
    (init-field [client (new tcp-client%)])
    (field
     [subscribed #f])
    (super-new)

    (define/private (get-response)
      (send client get-response))

    (define/private (apply-cmd cmd [args null])
      (send client apply-cmd cmd args))

    (define/private (apply-cmd* cmd [args null])
      (send client apply-cmd cmd args))

    (define/public (set-timeout t) (send client set-timeout t))

    (define/public (ping [msg null])
      (apply-cmd "PING" msg))

    (define/public (auth password)
      (apply-cmd "AUTH" password))

    (define/public (echo msg)
      (apply-cmd "ECHO" msg))

    (define/public (select index)
      (apply-cmd "SELECT" index))

    (define/public (quit)
      (apply-cmd "QUIT"))

    (define/public (exists keys)
      (apply-cmd "EXISTS" keys))

    (define/public (set key value)
      (apply-cmd "SET" (list key value)))

    (define/public (get key)
      (apply-cmd "GET" key))

    (define/public (mget keys)
      (apply-cmd "MGET" keys))

    (define/public (mset data)
      (apply-cmd "MSET" data))

    (define/public (msetnx data)
      (apply-cmd "MSETNX" data))

    (define/public (getset key value)
      (apply-cmd "GETSET" (list key value)))

    (define/public (incr key)
      (apply-cmd "INCR" key))

    (define/public (incrby key value)
      (apply-cmd "INCRBY" (list key value)))

    (define/public (decr key)
      (apply-cmd "DECR" key))

    (define/public (decrby key value)
      (apply-cmd "DECRBY" (list key value)))

    (define/public (del key)
      (apply-cmd "DEL" key))

    (define/public (setnx key value)
      (apply-cmd "SETNX" (list key value)))

    (define/public (lpush key value)
      (apply-cmd "LPUSH" (if (list? value)
                             (append (list key) value)
                             (list key value))))

    (define/public (rpush key value)
      (apply-cmd "RPUSH" (if (list? value)
                             (append (list key) value)
                             (list key value))))

    (define/public (lrange key min max)
      (apply-cmd "LRANGE" (list key min max)))

    (define/public (ltrim key start end)
      (apply-cmd "LTRIM" (list key start end)))

    (define/public (lindex key index)
      (apply-cmd "LINDEX" (list key index)))

    (define/public (lset key index value)
      (apply-cmd "LSET" (list key index value)))

    (define/public (lpop key string)
      (apply-cmd "LPOP" (list key string)))

    (define/public (rpop key string)
      (apply-cmd "RPOP" (list key string)))

    (define/public (blpop keys timeout)
      (apply-cmd "BLPOP" (append keys (list timeout))))

    (define/public (brpop keys timeout)
      (apply-cmd "BRPOP" (append keys (list timeout))))

    (define/public (rpoplpush srckey destkey)
      (apply-cmd "RPOPLPUSH" (list srckey destkey)))

    (define/public (sadd key member)
      (apply-cmd "SADD" (list key member)))

    (define/public (srem key member)
      (apply-cmd "SREM" (list key member)))

    (define/public (spop key)
      (apply-cmd "SPOP" key))

    (define/public (srandmember key)
      (apply-cmd "SRANDMEMBER" key))

    (define/public (smove srckey destkey member)
      (apply-cmd "SMOVE" (list srckey destkey member)))

    (define/public (scard key)
      (apply-cmd "SCARD" key))

    (define/public (sismember key member)
      (apply-cmd "SISMEMBER" (list key member)))

    (define/public (sinter keys)
      (apply-cmd "SINTER" keys))

    (define/public (sinterstore destkey srckeys)
      (apply-cmd "SINTERSTORE" (list destkey srckeys)))

    (define/public (sunion keys)
      (apply-cmd "SUNION" keys))

    (define/public (sunionstore destkey srckeys)
      (apply-cmd "SUNIONSTORE" (list destkey srckeys)))

    (define/public (sdiff keys)
      (apply-cmd "SDIFF" keys))

    (define/public (sdiffstore destkey srckeys)
      (apply-cmd "SDIFFSTORE" (list destkey srckeys)))

    (define/public (smembers key)
      (apply-cmd "SMEMBERS" key))

    (define/public (zadd key data)
      (apply-cmd "ZADD" (append (list key) data)))

    (define/public (zrem key member)
      (apply-cmd "ZREM" (append (list key) (if (list? member) member (list member)))))

    (define/public (zincrby key incr member)
      (apply-cmd "ZINCRBY" (list key incr member)))

    (define/public (zrange key start end)
      (apply-cmd "ZRANGE" (list key start end)))

    (define/public (zrevrange key start end)
      (apply-cmd "ZREVRANGE" (list key start end)))

    (define/public (zrangebyscore key min max)
      (apply-cmd "ZRANGEBYSCORE" (list key min max)))

    (define/public (zremrangebyscore key min max)
      (apply-cmd "ZREMRANGEBYSCORE" (list key min max)))

    (define/public (zcard key)
      (apply-cmd "ZCARD" key))

    (define/public (zscore key member)
      (apply-cmd "ZSCORE" (list key member)))

    (define/public (zlexcount key min max)
      (apply-cmd "ZLEXCOUNT" (list key min max)))

    (define/public (zrangebylex key min max)
      (apply-cmd "ZRANGEBYLEX" (list key min max)))

    (define/public (zinterstore dest keys)
      (apply-cmd "ZINTERSTORE" (append (list dest) keys)))

    (define/public (zcount key min max)
      (apply-cmd "ZCOUNT" (list key min max)))

    (define/public (zrevrank key member)
      (apply-cmd "ZREVRANK" (list key member)))

    (define/public (zrevrangebyscore key max min)
      (apply-cmd "ZREVRANGEBYSCORE" (list key max min)))

     (define/public (zremrangebyrank key start stop)
      (apply-cmd "ZREMRANGEBYSCORE" (list key start stop)))

    (define/public (zremrangebylex key min max)
      (apply-cmd "ZREMRANGEBYLEX" (list key min max)))

    (define/public (zunionstore dest keys)
      (apply-cmd "ZUNIONSTORE" (append (list dest) keys)))

    (define/public (hmset key data)
      (apply-cmd "HMSET" (append (list key) data)))

    (define/public (hvals key)
      (apply-cmd "HVALS" key))

    (define/public (hdel key fields)
      (apply-cmd "HDEL" (append (list key) fields)))

    (define/public (hsetnx key field value)
      (apply-cmd "HSETNX" (list key field value)))

    (define/public (hget key field)
      (apply-cmd "HGET" (list key field)))

    (define/public (hgetall key)
      (apply-cmd "HGETALL" key))

    (define/public (hincrby key field increment)
      (apply-cmd "HINCRBY" (list key field increment)))

    (define/public (hexists key field)
      (apply-cmd "HEXISTS" (list key field)))

    (define/public (hkeys key)
      (apply-cmd "HKEYS" key))

    (define/public (hlen key)
      (apply-cmd "HLEN" key))

    (define/public (concat key value)
      (apply-cmd "APPEND" (list key value)))

    (define/public (strlen key)
      (apply-cmd "STRLEN" key))

    (define/public (bitcount key [start "0"] [end (number->string (string-length key))])
      (apply-cmd "BITCOUNT" (list key start end)))

    (define/public (bitop operation destkey key)
      (apply-cmd "BITOP" (append (list operation destkey) (if (list? key) key (list key)))))

    (define/public (bitpos key bit [start null] [end null])
      (apply-cmd "BITPOS" (flatten (list key bit start end))))

    (define/public (watch key)
      (apply-cmd "WATCH" key))

    (define/public (unwatch)
      (apply-cmd "UNWATCH"))

    (define/public (getrange key start end)
      (apply-cmd "GETRANGE" (list key start end)))

    (define/public (type key)
      (apply-cmd "TYPE" key))

    (define/public (keys pattern)
      (apply-cmd "KEYS" pattern))

    (define/public (randomkey)
      (apply-cmd "RANDOMKEY"))

    (define/public (rename oldkey newkey)
      (apply-cmd "RENAME" (list oldkey newkey)))

    (define/public (renamex oldkey newkey)
      (apply-cmd "RENAMEX" (list oldkey newkey)))

    (define/public (config-get parameter)
      (apply-cmd "CONFIG GET" parameter))

    (define/public (config-set parameter value)
      (apply-cmd "CONFIG SET" (list parameter value)))

    (define/public (config-rewrite)
      (apply-cmd "CONFIG REWRITE"))

    (define/public (config-resetstat)
      (apply-cmd "CONFIG RESETSTAT"))

    (define/public (dbsize)
      (apply-cmd "DBSIZE"))

    (define/public (expire key seconds)
      (apply-cmd "EXPIRE" (list key seconds)))

    (define/public (expireat key unixtime)
      (apply-cmd "EXPIREAT" (list key unixtime)))

    (define/public (ttl key)
      (apply-cmd "TTL" key))

    (define/public (move key index)
      (apply-cmd "MOVE" (list key index)))

    (define/public (flushdb)
      (apply-cmd "FLUSHDB"))

    (define/public (flushall)
      (apply-cmd "FLUSHALL"))

    (define/public (save)
      (apply-cmd "SAVE"))

    (define/public (bgsave)
      (apply-cmd "BGSAVE"))

    (define/public (lastsave)
      (apply-cmd "LASTSAVE"))

    (define/public (bgrewriteaof)
      (apply-cmd "BGREWRITEAOF"))

    (define/public (shutdown)
      (apply-cmd "SHUTDOWN"))

    (define/public (info)
      (apply-cmd "INFO"))

    (define/public (monitor)
      (apply-cmd "MONITOR"))

    (define/public (object subcommand [args null])
      (apply-cmd "OBJECT" (append (list subcommand) args)))

    (define/public (slaveof host port)
      (apply-cmd "SLAVEOF" (list host port)))

    (define/public (publish channel msg)
      (apply-cmd "PUBLISH" (list channel msg)))

    (define/public (subscribe channel)
      (set! subscribed #t)
      (apply-cmd* "SUBSCRIBE" channel))

    (define/public (unsubscribe channel)
      (apply-cmd* "UNSUBSCRIBE" channel))

    (define/public (psubscribe pattern)
      (set! subscribed #t)
      (apply-cmd* "PSUBSCRIBE" pattern))

    (define/public (punsubscribe pattern)
      (apply-cmd* "PUNSUBSCRIBE" pattern))

    (define/public (init)
      (send client init))))
