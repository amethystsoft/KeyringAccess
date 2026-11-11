import CBigNumBoringSSL

struct FastCrypto {
    static func powMod(base: [UInt8], exp: [UInt8], modulus: [UInt8]) -> [UInt8]? {
        // Create a context for temporary variables used during calculation
        guard let ctx = CBigNumBoringSSL_BN_CTX_new() else { return nil }
        defer { CBigNumBoringSSL_BN_CTX_free(ctx) }
        
        let r = CBigNumBoringSSL_BN_new()
        let b = CBigNumBoringSSL_BN_new()
        let e = CBigNumBoringSSL_BN_new()
        let m = CBigNumBoringSSL_BN_new()
        
        defer {
            CBigNumBoringSSL_BN_free(r)
            CBigNumBoringSSL_BN_free(b)
            CBigNumBoringSSL_BN_free(e)
            CBigNumBoringSSL_BN_free(m)
        }
        
        // Validate BIGNUM allocations
        guard r != nil, b != nil, e != nil, m != nil else { return nil }

        // Convert byte arrays to BIGNUMs and verify success
        guard
            CBigNumBoringSSL_BN_bin2bn(base, base.count, b) != nil,
            CBigNumBoringSSL_BN_bin2bn(exp, exp.count, e) != nil,
            CBigNumBoringSSL_BN_bin2bn(modulus, modulus.count, m) != nil
        else {
            return nil
        }
        
        // Optimized modular exponentiation: r = (b ^ e) % m (returns 1 on success)
        guard CBigNumBoringSSL_BN_mod_exp_mont_consttime(r, b, e, m, ctx, nil) == 1 else {
            return nil
        }
        
        // Convert result back to bytes
        // Convert result back to bytes, left-padded to modulus length.
        var result = [UInt8](repeating: 0, count: modulus.count)
        let written = Int(CBigNumBoringSSL_BN_num_bytes(r))
        result.withUnsafeMutableBufferPointer { buf in
            _ = CBigNumBoringSSL_BN_bn2bin(r, buf.baseAddress!.advanced(by: modulus.count - written))
        }
        return result
    }
}
