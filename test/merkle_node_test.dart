import 'package:bsv/src/merkle_node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MerkleNode', () {
    //   test('should satisfy this basic API',  () {
    //     var merkle = new MerkleNode()
    //     should.exist(merkle)
    //     should.exist(merkle)
    //   })

    group('hash', () {
      test('should hash these buffers', () {
        var merkle1 = new MerkleNode(hashBuf: null, buf: []);
        var merkle2 = new MerkleNode(hashBuf: null, buf: []);
        var merkle = new MerkleNode(
          hashBuf: null,
          buf: null,
          merkle1: merkle1,
          merkle2: merkle2,
        );
        var hashBuf = merkle.hash();
        expect(hashBuf.data.length, 32);
        expect(
          hashBuf.toHex(),
          '352b71f195e85adbaefdcd6d7380d87067865d9a17c44d38982bb8a40bd0b393',
        );
        // and a second time ...
        hashBuf = merkle.hash();
        expect(
          hashBuf.toHex(),
          '352b71f195e85adbaefdcd6d7380d87067865d9a17c44d38982bb8a40bd0b393',
        );
      });

      test('should hash this buffer', () {
        var merkle = new MerkleNode(hashBuf: null, buf: []);
        var hashBuf = merkle.hash();
        expect(hashBuf.data.length, 32);

        expect(
          hashBuf.toHex(),
          '5df6e0e2761359d30a8275058e299fcc0381534545f55cf43e41983f5d4c9456',
        );
      });
    });

    group('#fromBuffers', () {
      test('should find this merkle root from three buffers', () {
        List<List<int>> bufs = [[], [], []];
        var merkle = new MerkleNode().fromBuffers(bufs);
        var hashBuf = merkle.hash();
        expect(hashBuf.data.length, 32);

        expect(
          hashBuf.toHex(),
          '647fedb4d19e11915076dd60fa72a8e03eb33f6dec87a4f0662b0c1f378a81cb',
        );

        expect(merkle.leavesNum(), 4);
      });

      test('should find this merkle root from four buffers', () {
        List<List<int>> bufs = [[], [], [], []];
        var merkle = new MerkleNode().fromBuffers(bufs);
        var hashBuf = merkle.hash();
        expect(hashBuf.data.length, 32);

        expect(
          hashBuf.toHex(),
          '647fedb4d19e11915076dd60fa72a8e03eb33f6dec87a4f0662b0c1f378a81cb',
        );

        expect(merkle.leavesNum(), 4);
      });

      test('should find this merkle root from 9 buffers', () {
        List<List<int>> bufs = List.generate(9, (index) => []);
        // for (var i = 0; i < 9; i++) {
        //   bufs[i] = Buffer.alloc(0)
        // }
        var merkle = new MerkleNode().fromBuffers(bufs);
        var hashBuf = merkle.hash();
        expect(hashBuf.data.length, 32);

        expect(
          hashBuf.toHex(),
          '9f187f4339d07e1963d404f31d28e4557cd72a320085d188f26c943fc604281e',
        );

        expect(merkle.leavesNum(), 16);
      });
    });

    group('@fromBuffers', () {
      test('should find this merkle root from three buffers', () {
        List<List<int>> bufs = [[], [], []];
        var merkle = MerkleNode.fromBuffers(bufs);
        var hashBuf = merkle.hash();
        expect(hashBuf.data.length, 32);

        expect(
          hashBuf.toHex(),
          '647fedb4d19e11915076dd60fa72a8e03eb33f6dec87a4f0662b0c1f378a81cb',
        );

        expect(merkle.leavesNum(), 4);
      });

      test('should find this merkle root from four buffers', () {
        List<List<int>> bufs = [[], [], [], []];
        var merkle = MerkleNode.fromBuffers(bufs);
        var hashBuf = merkle.hash();
        expect(hashBuf.data.length, 32);

        expect(
          hashBuf.toHex(),
          '647fedb4d19e11915076dd60fa72a8e03eb33f6dec87a4f0662b0c1f378a81cb',
        );

        expect(merkle.leavesNum(), 4);
      });

      test('should find this merkle root from 9 buffers', () {
        List<List<int>> bufs = List.generate(9, (index) => []);

        var merkle = MerkleNode.fromBuffers(bufs);
        var hashBuf = merkle.hash();
        expect(hashBuf.data.length, 32);

        expect(
          hashBuf.toHex(),
          '9f187f4339d07e1963d404f31d28e4557cd72a320085d188f26c943fc604281e',
        );

        expect(merkle.leavesNum(), 16);
      });
    });

    group('#fromBufferArrays', () {
      test('should find this merkle root from two buffers', () {
        List<List<int>> bufs1 = [[]];
        List<List<int>> bufs2 = [[]];
        var merkle = new MerkleNode().fromBufferArrays(bufs1, bufs2);
        var hashBuf = merkle.hash();

        expect(hashBuf.data.length, 32);
      });

      test('should find this merkle root from four buffers', () {
        List<List<int>> bufs1 = [[], []];
        List<List<int>> bufs2 = [[], []];
        var merkle = new MerkleNode().fromBufferArrays(bufs1, bufs2);
        var hashBuf = merkle.hash();

        expect(hashBuf.data.length, 32);
      });
    });

    group('@fromBufferArrays', () {
      test('should find this merkle root from two buffers', () {
        List<List<int>> bufs1 = [[]];
        List<List<int>> bufs2 = [[]];
        var merkle = MerkleNode.fromBufferArrays(bufs1, bufs2);
        var hashBuf = merkle.hash();

        expect(hashBuf.data.length, 32);
      });

      test('should find this merkle root from four buffers', () {
        List<List<int>> bufs1 = [[], []];
        List<List<int>> bufs2 = [[], []];
        var merkle = MerkleNode.fromBufferArrays(bufs1, bufs2);
        var hashBuf = merkle.hash();

        expect(hashBuf.data.length, 32);
      });
    });
  });
}
