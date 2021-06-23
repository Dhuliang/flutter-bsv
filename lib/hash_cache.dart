import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:bsv/extentsions/list.dart';

// ignore: slash_for_doc_comments
/**
 * Hash Cache
 * ==========
 *
 * For use in sighash.
 */

class HashCache {
  List<int> prevoutsHashBuf;
  List<int> sequenceHashBuf;
  List<int> outputsHashBuf;

  HashCache({
    this.prevoutsHashBuf,
    this.sequenceHashBuf,
    this.outputsHashBuf,
  });

  HashCache fromBuffer(List<int> buf) {
    return this.fromJSON(json.decode(utf8.decode(buf)));
  }

  List<int> toBuffer() {
    return utf8.encode(json.encode(this.toJSON()));
    // return hex.decode(json.encode(this.toJSON()));
  }

  HashCache fromJSON(Map json) {
    this.prevoutsHashBuf = json['prevoutsHashBuf'] != null
        ? hex.decode(json['prevoutsHashBuf'])
        : null;
    this.sequenceHashBuf = json['sequenceHashBuf'] != null
        ? hex.decode(json['sequenceHashBuf'])
        : null;
    this.outputsHashBuf = json['outputsHashBuf'] != null
        ? hex.decode(json['outputsHashBuf'])
        : null;
    return this;
  }

  Map<String, dynamic> toJSON() {
    return {
      "prevoutsHashBuf":
          this.prevoutsHashBuf != null ? this.prevoutsHashBuf.toHex() : null,
      "sequenceHashBuf":
          this.sequenceHashBuf != null ? this.sequenceHashBuf.toHex() : null,
      "outputsHashBuf":
          this.outputsHashBuf != null ? this.outputsHashBuf.toHex() : null,
    };
  }

  String toHex() {
    return this.toBuffer().toHex();
  }
}
