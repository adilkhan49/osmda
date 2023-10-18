for node in worker coordinator
do
    rm -r trino/$node/etc/catalog
    mkdir trino/$node/etc/catalog
    cp catalog/tpcds.properties catalog/tpch.properties trino/$node/etc/catalog
    for var in "$@"
        do
            cp catalog/$var.properties trino/$node/etc/catalog
        done
done
echo Copied: $@