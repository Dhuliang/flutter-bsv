Map<String, dynamic> ecdsaJson = {
  "valid": [
    {
      "d": "01",
      "k": "ec633bd56a5774a0940cb97e27a9e4e51dc94af737596a0c5cbb3d30332d92a5",
      "message":
          "Everything should be made as simple as possible, but not simpler.",
      "i": 0,
      "signature": {
        "r":
            "23362334225185207751494092901091441011938859014081160902781146257181456271561",
        "s":
            "50433721247292933944369538617440297985091596895097604618403996029256432099938"
      }
    },
    {
      "d": "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364140",
      "k": "9dc74cbfd383980fb4ae5d2680acddac9dac956dca65a28c80ac9c847c2374e4",
      "message":
          "Equations are more important to me, because politics is for the present, but an equation is something for eternity.",
      "i": 0,
      "signature": {
        "r":
            "38341707918488238920692284707283974715538935465589664377561695343399725051885",
        "s":
            "3180566392414476763164587487324397066658063772201694230600609996154610926757"
      }
    },
    {
      "d": "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364140",
      "k": "fd27071f01648ebbdd3e1cfbae48facc9fa97edc43bbbc9a7fdc28eae13296f5",
      "message":
          "Not only is the Universe stranger than we think, it is stranger than we can think.",
      "i": 0,
      "signature": {
        "r":
            "115464191557905790016094131873849783294273568009648050793030031933291767741904",
        "s":
            "50562520307781850052192542766631199590053690478900449960232079510155113443971"
      }
    },
    {
      "d": "0000000000000000000000000000000000000000000000000000000000000001",
      "k": "f0cd2ba5fc7c183de589f6416220a36775a146740798756d8d949f7166dcc87f",
      "message":
          "How wonderful that we have met with a paradox. Now we have some hope of making progress.",
      "i": 1,
      "signature": {
        "r":
            "87230998027579607140680851455601772643840468630989315269459846730712163783123",
        "s":
            "53231320085894623106179381504478252331065330583563809963303318469380290929875"
      }
    },
    {
      "d": "69ec59eaa1f4f2e36b639716b7c30ca86d9a5375c7b38d8918bd9c0ebc80ba64",
      "k": "6bb4a594ad57c1aa22dbe991a9d8501daf4688bf50a4892ef21bd7c711afda97",
      "message":
          "Computer science is no more about computers than astronomy is about telescopes.",
      "i": 0,
      "signature": {
        "r":
            "51348483531757779992459563033975330355971795607481991320287437101831125115997",
        "s":
            "6277080015686056199074771961940657638578000617958603212944619747099038735862"
      }
    },
    {
      "d": "00000000000000000000000000007246174ab1e92e9149c6e446fe194d072637",
      "k": "097b5c8ee22c3ea78a4d3635e0ff6fe85a1eb92ce317ded90b9e71aab2b861cb",
      "message":
          "...if you aren't, at any given time, scandalized by code you wrote five or even three years ago, you're not learning anywhere near enough",
      "i": 1,
      "signature": {
        "r":
            "113979859486826658566290715281614250298918272782414232881639314569529560769671",
        "s":
            "6517071009538626957379450615706485096874328019806177698938278220732027419959"
      }
    },
    {
      "d": "000000000000000000000000000000000000000000056916d0f9b31dc9b637f3",
      "k": "19355c36c8cbcdfb2382e23b194b79f8c97bf650040fc7728dfbf6b39a97c25b",
      "message":
          "The question of whether computers can think is like the question of whether submarines can swim.",
      "i": 1,
      "signature": {
        "r":
            "93122007060065279508564838030979550535085999589142852106617159184757394422777",
        "s":
            "3078539468410661027472930027406594684630312677495124015420811882501887769839"
      }
    }
  ],
  "invalid": {
    "verifystr": [
      {
        "description": "The wrong signature",
        "exception": "Invalid signature",
        "d": "01",
        "message": "foo",
        "signature": {
          "r":
              "38341707918488238920692284707283974715538935465589664377561695343399725051885",
          "s":
              "3180566392414476763164587487324397066658063772201694230600609996154610926757"
        }
      },
      {
        "description": "Invalid r value (< 0)",
        "exception": "r and s not in range",
        "d": "01",
        "message": "foo",
        "signature": {"r": "-1", "s": "2"}
      },
      {
        "description": "Invalid r value (== 0)",
        "exception": "r and s not in range",
        "d": "01",
        "message": "foo",
        "signature": {"r": "0", "s": "2"}
      },
      {
        "description": "Invalid r value (>= n)",
        "exception": "r and s not in range",
        "d": "01",
        "message": "foo",
        "signature": {
          "r":
              "115792089237316195423570985008687907852837564279074904382605163141518161494337",
          "s": "2"
        }
      },
      {
        "description": "Invalid s value (< 0)",
        "exception": "r and s not in range",
        "d": "01",
        "message": "foo",
        "signature": {"r": "2", "s": "-1"}
      },
      {
        "description": "Invalid s value (== 0)",
        "exception": "r and s not in range",
        "d": "01",
        "message": "foo",
        "signature": {"r": "2", "s": "0"}
      },
      {
        "description": "Invalid s value (>= n)",
        "exception": "r and s not in range",
        "d": "01",
        "message": "foo",
        "signature": {
          "r": "2",
          "s":
              "115792089237316195423570985008687907852837564279074904382605163141518161494337"
        }
      },
      {
        "description": "Invalid r, s values (r = s = -n)",
        "exception": "r and s not in range",
        "d": "01",
        "message": "foo",
        "signature": {
          "r":
              "-115792089237316195423570985008687907852837564279074904382605163141518161494337",
          "s":
              "-115792089237316195423570985008687907852837564279074904382605163141518161494337"
        }
      }
    ]
  },
  "deterministicK": [
    {
      "message": "test data",
      "privkey":
          "fee0a1f7afebf9d2a5a80c0c98a31c709681cce195cbcd06342b517970c0be1e",
      "k_bad00":
          "fcce1de7a9bcd6b2d3defade6afa1913fb9229e3b7ddf4749b55c4848b2a196e",
      "k_bad01":
          "727fbcb59eb48b1d7d46f95a04991fc512eb9dbf9105628e3aec87428df28fd8",
      "k_bad15":
          "398f0e2c9f79728f7b3d84d447ac3a86d8b2083c8f234a0ffa9c4043d68bd258"
    },
    {
      "message":
          "Everything should be made as simple as possible, but not simpler.",
      "privkey":
          "0000000000000000000000000000000000000000000000000000000000000001",
      "k_bad00":
          "ec633bd56a5774a0940cb97e27a9e4e51dc94af737596a0c5cbb3d30332d92a5",
      "k_bad01":
          "df55b6d1b5c48184622b0ead41a0e02bfa5ac3ebdb4c34701454e80aabf36f56",
      "k_bad15":
          "def007a9a3c2f7c769c75da9d47f2af84075af95cadd1407393dc1e26086ef87"
    },
    {
      "message": "Satoshi Nakamoto",
      "privkey":
          "0000000000000000000000000000000000000000000000000000000000000002",
      "k_bad00":
          "d3edc1b8224e953f6ee05c8bbf7ae228f461030e47caf97cde91430b4607405e",
      "k_bad01":
          "f86d8e43c09a6a83953f0ab6d0af59fb7446b4660119902e9967067596b58374",
      "k_bad15":
          "241d1f57d6cfd2f73b1ada7907b199951f95ef5ad362b13aed84009656e0254a"
    },
    {
      "message": "Diffie Hellman",
      "privkey":
          "7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f",
      "k_bad00":
          "c378a41cb17dce12340788dd3503635f54f894c306d52f6e9bc4b8f18d27afcc",
      "k_bad01":
          "90756c96fef41152ac9abe08819c4e95f16da2af472880192c69a2b7bac29114",
      "k_bad15":
          "7b3f53300ab0ccd0f698f4d67db87c44cf3e9e513d9df61137256652b2e94e7c"
    },
    {
      "message": "Japan",
      "privkey":
          "8080808080808080808080808080808080808080808080808080808080808080",
      "k_bad00":
          "f471e61b51d2d8db78f3dae19d973616f57cdc54caaa81c269394b8c34edcf59",
      "k_bad01":
          "6819d85b9730acc876fdf59e162bf309e9f63dd35550edf20869d23c2f3e6d17",
      "k_bad15":
          "d8e8bae3ee330a198d1f5e00ad7c5f9ed7c24c357c0a004322abca5d9cd17847"
    },
    {
      "message": "Bitcoin",
      "privkey":
          "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364140",
      "k_bad00":
          "36c848ffb2cbecc5422c33a994955b807665317c1ce2a0f59c689321aaa631cc",
      "k_bad01":
          "4ed8de1ec952a4f5b3bd79d1ff96446bcd45cabb00fc6ca127183e14671bcb85",
      "k_bad15":
          "56b6f47babc1662c011d3b1f93aa51a6e9b5f6512e9f2e16821a238d450a31f8"
    },
    {
      "message": "i2FLPP8WEus5WPjpoHwheXOMSobUJVaZM1JPMQZq",
      "privkey":
          "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364140",
      "k_bad00":
          "6e9b434fcc6bbb081a0463c094356b47d62d7efae7da9c518ed7bac23f4e2ed6",
      "k_bad01":
          "ae5323ae338d6117ce8520a43b92eacd2ea1312ae514d53d8e34010154c593bb",
      "k_bad15":
          "3eaa1b61d1b8ab2f1ca71219c399f2b8b3defa624719f1e96fe3957628c2c4ea"
    },
    {
      "message": "lEE55EJNP7aLrMtjkeJKKux4Yg0E8E1SAJnWTCEh",
      "privkey":
          "3881e5286abc580bb6139fe8e83d7c8271c6fe5e5c2d640c1f0ed0e1ee37edc9",
      "k_bad00":
          "5b606665a16da29cc1c5411d744ab554640479dd8abd3c04ff23bd6b302e7034",
      "k_bad01":
          "f8b25263152c042807c992eacd2ac2cc5790d1e9957c394f77ea368e3d9923bd",
      "k_bad15":
          "ea624578f7e7964ac1d84adb5b5087dd14f0ee78b49072aa19051cc15dab6f33"
    },
    {
      "message": "2SaVPvhxkAPrayIVKcsoQO5DKA8Uv5X/esZFlf+y",
      "privkey":
          "7259dff07922de7f9c4c5720d68c9745e230b32508c497dd24cb95ef18856631",
      "k_bad00":
          "3ab6c19ab5d3aea6aa0c6da37516b1d6e28e3985019b3adb388714e8f536686b",
      "k_bad01":
          "19af21b05004b0ce9cdca82458a371a9d2cf0dc35a813108c557b551c08eb52e",
      "k_bad15":
          "117a32665fca1b7137a91c4739ac5719fec0cf2e146f40f8e7c21b45a07ebc6a"
    },
    {
      "message": "00A0OwO2THi7j5Z/jp0FmN6nn7N/DQd6eBnCS+/b",
      "privkey":
          "0d6ea45d62b334777d6995052965c795a4f8506044b4fd7dc59c15656a28f7aa",
      "k_bad00":
          "79487de0c8799158294d94c0eb92ee4b567e4dc7ca18addc86e49d31ce1d2db6",
      "k_bad01":
          "9561d2401164a48a8f600882753b3105ebdd35e2358f4f808c4f549c91490009",
      "k_bad15":
          "b0d273634129ff4dbdf0df317d4062a1dbc58818f88878ffdb4ec511c77976c0"
    }
  ]
};
