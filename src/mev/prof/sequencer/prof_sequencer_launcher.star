ADMIN_KEY_INDEX = 0
USER_KEY_INDEX = 2

# The min/max CPU/memory that prof_sequencer can use
MIN_CPU = 100
MAX_CPU = 1000
MIN_MEMORY = 128
MAX_MEMORY = 1024


def launch_prof_sequencer(
    plan,
    image,
    el_uri,
    global_node_selectors,
):
    plan.add_service(
        name="prof-sequencer",
        config=ServiceConfig(
            image=image,
            entrypoint=[
                "/bin/sh",
                "-c",
                "touch sequencer.log && tail -F sequencer.log",
            ],
            min_cpu=MIN_CPU,
            max_cpu=MAX_CPU,
            min_memory=MIN_MEMORY,
            max_memory=MAX_MEMORY,
            node_selectors=global_node_selectors,
        ),
    )
