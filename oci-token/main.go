package main

import (
	"context"
	"io/ioutil"
	"log"
	"os"

	"github.com/oracle/oci-go-sdk/containerengine"
	"github.com/oracle/oci-go-sdk/v49/common"
)

func main() {
	tenancy_ocid := os.Getenv("TF_VAR_tenancy_ocid")
	user_ocid := os.Getenv("TF_VAR_user_ocid")
	region := os.Getenv("TF_VAR_region")
	fingerprint := os.Getenv("TF_VAR_fingerprint")
	private_key := os.Getenv("TF_VAR_private_key")

	config := common.NewRawConfigurationProvider(tenancy_ocid, user_ocid, region, fingerprint, private_key, nil)
	client, err := containerengine.NewContainerEngineClientWithConfigurationProvider(config)
	if err != nil {
		log.Fatal(err)
	}

	clusterId := "ocid1.cluster.oc1.us-chicago-1.aaaaaaaagzhrbov2g7ret64plikugkuaxe6qrbepw6iqtzsvbcpujurqjxvq"

	resp, err := client.CreateKubeconfig(context.Background(), containerengine.CreateKubeconfigRequest{
		ClusterId: &clusterId,
	})
	if err != nil {
		log.Fatal(err)
	}
	body, err := ioutil.ReadAll(resp.Content)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("%s", body)
}
