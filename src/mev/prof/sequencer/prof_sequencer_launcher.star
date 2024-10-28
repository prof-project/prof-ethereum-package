# The min/max CPU/memory that prof_sequencer can use
MIN_CPU = 100
MAX_CPU = 1000
MIN_MEMORY = 128
MAX_MEMORY = 1024

KURTOSIS_API_PORT = 8080
KURTOSIS_API_PORT_NAME = "http"


def launch_prof_sequencer(
    plan,
    image,
    el_uri,
    global_node_selectors,
):
    service = plan.add_service(
        name="prof-sequencer",
        config=ServiceConfig(
            image=image,
            entrypoint=["/servicebinary"],
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
        service_name="prof-sequencer",
        recipe=ExecRecipe(
            command=[
                "/bin/sh",
                "-c",
                "uname -a",
            ]
        ),
    )

    return "http://{0}:{1}".format(
        service.ip_address,
        KURTOSIS_API_PORT
    )
