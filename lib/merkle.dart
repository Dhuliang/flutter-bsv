// ignore: slash_for_doc_comments
/**
 * Merkle
 * ======
 *
 * A node in a Merkle tree (possibly the root node, in which case it is the
 * Merkle root). A node either contains a buffer or links to two other nodes.
 */

class Merkle {
  List<int> hashBuf;
  List<int> buf;
}
