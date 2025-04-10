#!/bin/sh
OUT="security-checker/reports/output.html"
echo "<pre>" > $OUT
echo "🔍 Verificando configurações de segurança..." | tee -a $OUT

grep '<port>8443</port>' /conf/config.xml >/dev/null && echo '✅ Porta WebGUI: 8443' || echo '❌ Porta WebGUI incorreta'
pfctl -sn | grep -q 'redirect.*53.*192.168.1.1' && echo '✅ NAT DNS Hijack ativo' || echo '❌ NAT DNS Hijack ausente'

for p in 23 123 137 138 139 5353 1900; do
  echo -n "Porta $p: " | tee -a $OUT
  pfctl -sr | grep -q $p && echo '✅ Bloqueada' || echo '❌ NÃO bloqueada'
done

grep -q GeoBlock /conf/config.xml && echo '✅ GeoIP configurado' || echo '❌ GeoIP ausente'
pfctl -sr | grep -q 'ff02::' && echo '✅ IPv6 Multicast bloqueado' || echo '❌ IPv6 Multicast não bloqueado'

echo "✔️ Verificação concluída." | tee -a $OUT
echo "</pre>" >> $OUT
