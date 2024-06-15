export function calcularHashSHA256(texto: string): string {
  // Convertir la cadena de texto en un array de bytes UTF-8
  const bytes = new TextEncoder().encode(texto);

  // Funciones de rotación y funciones auxiliares
  function rotr(n: number, x: number): number {
    return (x >>> n) | (x << (32 - n));
  }

  function ch(x: number, y: number, z: number): number {
    return (x & y) ^ (~x & z);
  }

  function maj(x: number, y: number, z: number): number {
    return (x & y) ^ (x & z) ^ (y & z);
  }

  function sigma0(x: number): number {
    return rotr(2, x) ^ rotr(13, x) ^ rotr(22, x);
  }

  function sigma1(x: number): number {
    return rotr(6, x) ^ rotr(11, x) ^ rotr(25, x);
  }

  function epsilon0(x: number): number {
    return rotr(7, x) ^ rotr(18, x) ^ (x >>> 3);
  }

  function epsilon1(x: number): number {
    return rotr(17, x) ^ rotr(19, x) ^ (x >>> 10);
  }

  // Constantes para el algoritmo SHA-256
  const K = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
  ];

  // Inicializar variables
  let [H0, H1, H2, H3, H4, H5, H6, H7] = [
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
  ];

  // Preprocesamiento: agregar padding y longitud original
  const paddedBytes = [...bytes, 0x80];
  while (paddedBytes.length % 64 !== 56) {
    paddedBytes.push(0);
  }
  const length = bytes.length * 8;
  for (let i = 7; i >= 0; i--) {
    paddedBytes.push((length >>> (i * 8)) & 0xff);
  }

  // Procesar bloques de 512 bits
  for (let i = 0; i < bytes.length; i += 64) {
    const W = new Array(64).fill(0);

    // Expandir el bloque de 512 bits a 64 palabras de 32 bits
    for (let t = 0; t < 16; t++) {
      W[t] = (bytes[i + (t * 4)] << 24) | (bytes[i + (t * 4) + 1] << 16) | (bytes[i + (t * 4) + 2] << 8) | bytes[i + (t * 4) + 3];
    }
    for (let t = 16; t < 64; t++) {
      W[t] = (epsilon1(W[t - 2]) + W[t - 7] + epsilon0(W[t - 15]) + W[t - 16]) >>> 0;
    }

    // Inicializar variables de trabajo
    let [a, b, c, d, e, f, g, h] = [H0, H1, H2, H3, H4, H5, H6, H7];

    // Comprimir el bloque de 512 bits
    for (let t = 0; t < 64; t++) {
      const T1 = (h + sigma1(e) + ch(e, f, g) + K[t] + W[t]) >>> 0;
      const T2 = (sigma0(a) + maj(a, b, c)) >>> 0;
      h = g;
      g = f;
      f = e;
      e = (d + T1) >>> 0;
      d = c;
      c = b;
      b = a;
      a = (T1 + T2) >>> 0;
    }

    // Actualizar los valores de los registros
    [H0, H1, H2, H3, H4, H5, H6, H7] = [
      (H0 + a) >>> 0, (H1 + b) >>> 0, (H2 + c) >>> 0, (H3 + d) >>> 0,
      (H4 + e) >>> 0, (H5 + f) >>> 0, (H6 + g) >>> 0, (H7 + h) >>> 0
    ];
  }

  // Concatenar los valores finales de los registros para obtener el hash
  const hash = [H0, H1, H2, H3, H4, H5, H6, H7]
    .map(val => val.toString(16).padStart(8, '0'))
    .join('');

  return hash;
}
