# The min/max CPU/memory that prof_merger can use
MIN_CPU = 100
MAX_CPU = 1000
MIN_MEMORY = 128
MAX_MEMORY = 1024

KURTOSIS_API_PORT = 50051
KURTOSIS_API_PORT_NAME = "tcp"


def launch_prof_merger(
    plan,
    image,
    el_uri,
    global_node_selectors,
):
    plan.add_service(
        name="prof-merger",
        config=ServiceConfig(
            image=image,
            entrypoint=["/enclave-server"],
            min_cpu=MIN_CPU,
            max_cpu=MAX_CPU,
            min_memory=MIN_MEMORY,
            max_memory=MAX_MEMORY,
            node_selectors=global_node_selectors,
            ports = {
                "http": PortSpec(
                    number = KURTOSIS_API_PORT,
                    application_protocol = KURTOSIS_API_PORT_NAME,
                ),
            },
        ),
    )

    plan.exec(
        service_name="prof-merger",
        recipe=ExecRecipe(
            command=[
                "/bin/sh",
                "-c",
                "uname -a",
            ]
        ),
    )
