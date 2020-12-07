/**
  *恒定时间缓冲区比较
  * ===========================
  *
  *恒定时间比较功能。 这应该在任何安全性中使用
  *敏感的代码，其中泄漏的计时信息可能导致减少
  *安全。 请注意，如果缓冲区的长度不相等，则此函数
  *循环获取最长的缓冲区，可能没有必要。 通常这个
  *函数应用于长度相等的缓冲区，
  *例如哈希，尤其是Hmacs。
  *
  *此处的算法是将每个字节（如果未定义，则为0）与
  *对应的其他字节，然后与总和（d）进行或运算
  *从这里改编：
**/
import 'dart:typed_data';

/**
 * Constant-Time Buffer Compare
 * ============================
 *
 * A constant-time comparison function. This should be used in any security
 * sensitive code where leaking timing information may lead to lessened
 * security. Note that if the buffers are not equal in length, this function
 * loops for the longest buffer, which may not be necessary. Usually this
 * function should be used for buffers that would otherwise be equal length,
 * such as a hash, particularly Hmacs.
 *
 * The algorithm here, which is XORs each byte (or, if undefined, 0) with the
 * corresponding other byte, and then ORs that with a running total (d), is
 * adapted from here:
 *
 * https://groups.google.com/forum/#!topic/keyczar-discuss/VXHsoJSLKhM
 */

bool cmp(Uint8List buf1, Uint8List buf2) {
  if (buf1.length != buf2.length) {
    return false;
  }

  var d = 0;
  for (var i = 0; i < buf1.length; i++) {
    var x = buf1[i];
    var y = buf2[i];
    d |= x ^ y;
  }

  return d == 0;
}
